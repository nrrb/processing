public class pLinkedList {
  protected pOneChildNode head;
  protected int number;
  
  public pLinkedList() {
    head = null;
    number = 0;
  }
  public boolean isEmpty() {
    return (head == null);
  }
  public int size() {
    return number;
  }
  public void insert(Object obj) {
    head = new pOneChildNode(obj, head);
    number += 1;
  }
  public Object remove() {
    if(isEmpty()) {
      return null;
    }
    pOneChildNode tmp = head;
    head = tmp.getNext();
    number -= 1;
    return tmp.getData();
  }
  public void insertEnd(Object obj) {
    if(isEmpty()) {
      insert(obj);
    } else {
      pOneChildNode t = head;
      while(t.getNext() != null) {
        t = t.getNext();
      }
      pOneChildNode tmp = new pOneChildNode(obj, t.getNext()); // same as pOneChildNode(obj, null)
      t.setNext(tmp);
      number += 1;
    }
  }
  public Object removeEnd() {
    if(isEmpty()) {
      return null;
    }
    if(head.getNext() == null) {
      return remove();
    }
    pOneChildNode t = head;
    while(t.getNext().getNext() != null) {
      t = t.getNext();
    }
    Object obj = t.getNext().getData();
    t.setNext(t.getNext().getNext()); // or t.setNext(null);
    number -= 1;
    return obj;
  }
  public Object peek(int n) {
    pOneChildNode t = head;
    for(int i = 0; i < n && t != null; i++) {
      t = t.getNext();
    }
    return t.getData();
  }
}

public class pOneChildNode {
  protected Object data;
  protected pOneChildNode next;
  
  public pOneChildNode() {
    data = null;
    next = null;
  }
  public pOneChildNode(Object d, pOneChildNode n) {
    data = d;
    next = n;
  }
  public void setNext(pOneChildNode n) {
    next = n;
  }
  public void setData(Object d) {
    data = d;
  }
  public Object getData() {
    return data;
  }
  public pOneChildNode getNext() {
    return next;
  }
  public String toString() {
    return "" + data;
  }
}
