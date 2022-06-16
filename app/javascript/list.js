export default class List {
    static ITEM_SELECTOR = ".item";
    static ITEM_INDEX_ATTRIBUTE = "data-item-index";

    static ADD = 0;
    static REMOVE = 1;
    static MOVE = 2;

    get parent() {
        return this._parent;
    }

    get items() {
        return this._items;
    }

    get length() {
        return this.items.length;
    }

    get first() {
        return length > 0 ? this.items[0] : null;
    }

    get last() {
        return length > 0 ? this.items[length - 1] : null;
    }

    constructor(parent, callback=null) {
        this._parent = $(parent)[0];
        this.initialize(callback);
    }

    initialize(callback=null) {
        this._callback = callback;
        this.initializeItems();
    }

    initializeItems() {
        const items = $(this.parent).children(List.ITEM_SELECTOR);
        let i = 0;
        for(let item of items) {
            $(item).attr(List.ITEM_INDEX_ATTRIBUTE, i);
            i++;
        }
        this._items = items.toArray();
    }

    move(itemIndex, targetItemIndex) {
        let idx = Math.max(Math.min(itemIndex, this.length - 1), 0);
        let tidx = Math.max(Math.min(targetItemIndex, this.length), 0);
        console.log(idx, tidx);
        if(tidx == idx) return;
        const item = this.items[idx];

        if(tidx == this.length) {
            const titem = this.last;
            $(item).insertAfter(titem);
        } else {
            const titem = this.items[tidx];

            if(tidx == idx + 1) $(item).insertAfter(titem);
            else $(item).insertBefore(titem);
        }

        this.initializeItems();

        if(this._callback != null)
            this._callback(List.MOVE, {itemIndex, targetItemIndex});
    }

    addBefore(itemIndex) {
        let idx = Math.max(Math.min(itemIndex, this.length - 1), 0);
        const item = this.items[idx];
        
        const clone = $(item).clone()[0];
        $(clone).insertBefore(item);

        this.initializeItems();

        if(this._callback != null)
            this._callback(List.ADD, {itemIndex, element: clone});
    }

    addAfter(itemIndex) {
        let idx = Math.max(Math.min(itemIndex, this.length - 1), 0);
        const item = this.items[idx];
        
        const clone = $(item).clone()[0];
        $(clone).insertAfter(item);

        this.initializeItems();

        if(this._callback != null)
            this._callback(List.ADD, {itemIndex, element: clone});
    }

    remove(...itemIndices) {
        const items = [];
        for(let i of itemIndices) {
            let idx = Math.max(Math.min(i, this.length - 1), 0);
            items.push(this.items[idx]);
        }

        for(let item of items) $(item).remove();

        this.initializeItems();

        if(this._callback != null)
            this._callback(List.REMOVE, {itemIndices});
    }

    indexOf(item) {
        return this.items.indexOf(item);
    }
}